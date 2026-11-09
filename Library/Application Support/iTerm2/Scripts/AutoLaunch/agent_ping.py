#!/usr/bin/env python3
"""Posts agent-ping banners as macOS notifications (dotfiles D44, D45).

agent-ping on the dev VM writes OSC 1337 ; Custom=id=agent-ping:<base64 JSON> to iTerm2, with
title, subtitle, body and group. This script shows it through alerter (a newer banner for the
same group replaces the older one) and, when the banner is clicked, brings forward the iTerm2
session that received it. Text goes to alerter as arguments, never through a shell.
"""
import asyncio
import base64
import json
import os

import iterm2

ALERTER = next(
    (p for p in ("/opt/homebrew/bin/alerter", "/usr/local/bin/alerter") if os.path.exists(p)),
    "alerter",
)


async def notify(app, session_id, payload):
    try:
        msg = json.loads(base64.b64decode(payload))
    except ValueError:
        return
    args = [ALERTER, "--message", msg.get("body") or " ", "--title", msg.get("title", "agent-ping"),
            "--sound", "default", "--sender", "com.googlecode.iterm2"]
    if msg.get("subtitle"):
        args += ["--subtitle", msg["subtitle"]]
    if msg.get("group"):
        args += ["--group", "agent-ping:" + msg["group"]]
    proc = await asyncio.create_subprocess_exec(*args, stdout=asyncio.subprocess.PIPE)
    out, _ = await proc.communicate()
    if out.strip() == b"@CONTENTCLICKED":
        session = app.get_session_by_id(session_id)
        if session:
            await session.async_activate(select_tab=True, order_window_front=True)
        await app.async_activate()


async def main(connection):
    app = await iterm2.async_get_app(connection)

    async def watch(session_id):
        async with iterm2.CustomControlSequenceMonitor(connection, "agent-ping", r"^(.*)$", session_id) as mon:
            while True:
                match = await mon.async_get()
                asyncio.create_task(notify(app, session_id, match.group(1)))

    await iterm2.EachSessionOnceMonitor.async_foreach_session_create_task(app, watch)


iterm2.run_forever(main)
