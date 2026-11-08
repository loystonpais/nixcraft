"""Smoke checks for the generated, context-specific option references."""

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HUMAN = ROOT / "docs/human/options-tree"
AGENT = ROOT / "docs/agent/options-tree"
CONTEXTS = ("nixos", "home-manager", "client", "server")


class GeneratedOptionsTreeTest(unittest.TestCase):
    def test_all_contexts_have_both_formats(self):
        for name in CONTEXTS:
            with self.subTest(context=name):
                md = (HUMAN / f"{name}.md").read_text(encoding="utf-8")
                toon = (AGENT / f"{name}.toon").read_text(encoding="utf-8")
                self.assertIn("# Nixcraft Options Tree:", md)
                self.assertIn("format: TOON\n", toon)
                self.assertIn("options:\n", toon)

    def test_options_are_scoped_to_interface(self):
        nixos = (HUMAN / "nixos.md").read_text(encoding="utf-8")
        hm = (HUMAN / "home-manager.md").read_text(encoding="utf-8")
        client = (HUMAN / "client.md").read_text(encoding="utf-8")
        server = (HUMAN / "server.md").read_text(encoding="utf-8")
        self.assertIn('**`cache`**', nixos)
        self.assertIn('**`renice`**', nixos)
        self.assertIn('"/var/lib/nixcraft/client/instances"', nixos)
        self.assertNotIn('**`cache`**', hm)
        self.assertIn('"/(root)/.local/share/nixcraft/client/instances"', hm)
        self.assertIn('**`desktopEntry`**', client)
        self.assertNotIn('**`desktopEntry`**', server)
        self.assertIn('**`agreeToEula`**', server)
        self.assertNotIn('**`agreeToEula`**', client)
        self.assertNotIn('**`nixcraft`**', client)

    def test_navigation_targets_exist(self):
        summary = (ROOT / "docs/human/SUMMARY.md").read_text(encoding="utf-8")
        readme = (ROOT / "README.md").read_text(encoding="utf-8")
        for name in CONTEXTS:
            with self.subTest(context=name):
                self.assertIn(f"./options-tree/{name}.md", summary)
                self.assertIn(f"../agent/options-tree/{name}.toon", summary)
                self.assertIn(f"docs/human/options-tree/{name}.md", readme)
        self.assertFalse((ROOT / "docs/human/OPTIONS-TREE.md").exists())
        self.assertFalse((ROOT / "docs/agent/options-tree.toon").exists())


if __name__ == "__main__":
    unittest.main()
