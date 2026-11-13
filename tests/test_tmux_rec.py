import importlib.machinery
import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import time
import unittest

SCRIPT = os.path.join(os.path.dirname(__file__), "..", "dot_local", "bin", "executable_tmux-rec")
loader = importlib.machinery.SourceFileLoader("tmux_rec", SCRIPT)
spec = importlib.util.spec_from_loader("tmux_rec", loader)
rec = importlib.util.module_from_spec(spec)
loader.exec_module(rec)

# Stands in for `tmux display -p`, the one tmux call `record` makes before its first gap.
FAKE_TMUX = """#!/bin/sh
printf '80\\t24\\tproj\\t2\\tzsh\\t1\\t/tmp\\ttmux-256color\\n'
"""


class Sessions(unittest.TestCase):
    def test_add_keeps_order_and_dedupes(self):
        self.assertEqual(rec.add_session(["a"], "b"), ["a", "b"])
        self.assertEqual(rec.add_session(["a", "b"], "a"), ["a", "b"])

    def test_remove(self):
        self.assertEqual(rec.remove_session(["a", "b", "c"], "b"), ["a", "c"])

    def test_rename(self):
        self.assertEqual(rec.rename_session(["a", "b"], "a", "x"), ["x", "b"])
        self.assertEqual(rec.rename_session(["a", "x"], "a", "x"), ["x"])

    def test_file_round_trip(self):
        with tempfile.TemporaryDirectory() as d:
            rec.ROOT, rec.SESSIONS = d, os.path.join(d, "sessions")
            self.assertEqual(rec.read_sessions(), [])
            rec.write_sessions(["a", "b c"])
            self.assertEqual(rec.read_sessions(), ["a", "b c"])
            self.assertEqual(os.stat(rec.SESSIONS).st_mode & 0o777, 0o600)


class Record(unittest.TestCase):
    def test_multibyte_split_across_reads(self):
        with tempfile.TemporaryDirectory() as d:
            tmux = os.path.join(d, "tmux")
            with open(tmux, "w") as f:
                f.write(FAKE_TMUX)
            os.chmod(tmux, 0o755)
            cast = os.path.join(d, "x.cast")
            env = dict(os.environ, PATH=d + os.pathsep + os.environ["PATH"])
            p = subprocess.Popen([sys.executable, SCRIPT, "record", "%5", cast],
                                 stdin=subprocess.PIPE, env=env)
            é = "é".encode()
            p.stdin.write(b"caf" + é[:1])
            p.stdin.flush()
            time.sleep(0.2)
            p.stdin.write(é[1:] + b"!\r\n")
            p.stdin.close()
            p.wait(5)
            with open(cast) as f:
                lines = [json.loads(line) for line in f]
        self.assertEqual(lines[0]["width"], 80)
        self.assertEqual(lines[0]["tmux"]["pane_id"], "%5")
        self.assertEqual(lines[0]["tmux"]["session"], "proj")
        self.assertEqual("".join(e[2] for e in lines[1:]), "café!\r\n")
        self.assertTrue(all(e[1] == "o" for e in lines[1:]))


class Search(unittest.TestCase):
    def test_strips_escapes(self):
        events = [[0.5, "o", "\x1b[1;31mred\x1b[0m \x1b]0;title\x07plain \x1b(B\x1b=x\ty\x07\r\n"]]
        self.assertEqual(rec.cast_lines(events), [(0.5, "red plain x y")])

    def test_osc_ended_by_st(self):
        self.assertEqual(rec.cast_lines([[1, "o", "a\x1b]8;;http://x\x1b\\b\n"]]), [(1, "ab")])

    def test_line_start_times_across_events(self):
        # "\r" then "\n" in the next read is one break; an escape split across reads is still stripped
        events = [[1.0, "o", "echo hi"], [1.5, "r", "80x24"], [2.0, "o", "\r\nhi\r"],
                  [3.0, "o", "\nnext \x1b["], [4.0, "o", "Kmore"]]
        self.assertEqual(rec.cast_lines(events),
                         [(1.0, "echo hi"), (2.0, "hi"), (3.0, "next more")])

    def test_lone_cr_breaks_line(self):
        self.assertEqual(rec.cast_lines([[0, "o", "50%\r100%"]]), [(0, "50%"), (0, "100%")])

    def test_shift_events(self):
        events = [[1.0, "o", "a"], [8.0, "o", "b"], [10.0, "o", "hit"], [12.0, "o", "c"]]
        self.assertEqual(rec.shift_events(events, 10.0),
                         [[0, "o", "a"], [3.0, "o", "b"], [5.0, "o", "hit"], [7.0, "o", "c"]])

    def test_shift_events_hit_near_start(self):
        events = [[1.0, "o", "a"], [3.0, "o", "hit"]]
        self.assertEqual(rec.shift_events(events, 3.0), events)

    def test_grep_cast_and_snapshot(self):
        with tempfile.TemporaryDirectory() as d:
            rec.ROOT = d
            os.mkdir(os.path.join(d, "proj"))
            with open(os.path.join(d, "proj", "20261113-140211-w2p1.cast"), "w") as f:
                f.write(json.dumps({"version": 2, "width": 80, "height": 24, "timestamp": 1000}) + "\n")
                f.write(json.dumps([3, "o", "\x1b[1mmake test\x1b[0m\r\n"]) + "\n")
            with open(os.path.join(d, "proj", "20261113-140211-w2p1.txt"), "w") as f:
                f.write("old\nMake Test earlier\n")
            hits = rec.grep("make test", flags=rec.re.I)
        when = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(1003))
        self.assertEqual([h.split("\t")[0] for h in hits],
                         [f"proj  w2p1  {when}  make test", "proj  w2p1  snapshot  Make Test earlier"])
        self.assertEqual([h.split("\t")[2] for h in hits], ["0", "1"])


if __name__ == "__main__":
    unittest.main()
