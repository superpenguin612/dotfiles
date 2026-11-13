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
            lines = [json.loads(line) for line in open(cast)]
        self.assertEqual(lines[0]["width"], 80)
        self.assertEqual(lines[0]["tmux"]["pane_id"], "%5")
        self.assertEqual(lines[0]["tmux"]["session"], "proj")
        self.assertEqual("".join(e[2] for e in lines[1:]), "café!\r\n")
        self.assertTrue(all(e[1] == "o" for e in lines[1:]))


if __name__ == "__main__":
    unittest.main()
