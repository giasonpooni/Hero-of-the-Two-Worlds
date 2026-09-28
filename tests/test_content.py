"""Data contract regressions. Runtime behaviour is tested separately in Godot."""
import copy
import json
import tempfile
import unittest
from pathlib import Path
from jsonschema import ValidationError
from tools.validate import ROOT, read_json, validate_repo, validate_world


class ContentTests(unittest.TestCase):
    def setUp(self):
        self.world = read_json(ROOT / "data/world/nizza_1824.json")

    def test_repository_validates(self):
        self.assertEqual(validate_repo(), [])

    def test_seed_matches_contract(self):
        validate_world(self.world)

    def test_wrong_version_rejected(self):
        self.world["schema_version"] = "world-state.v2"
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_wrong_project_rejected(self):
        self.world["project_id"] = "1792"
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_future_campaign_save_rejected(self):
        self.world["year"] = 1860
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_invented_stage_rejected(self):
        self.world["mission"]["stage"] = "victorious"
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_inventory_cannot_skip_mission(self):
        self.world["mission"]["has_manifest"] = True
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_trust_cannot_precede_completion(self):
        self.world["relationships"]["dock_contact"] = 1
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_unknown_fields_rejected(self):
        self.world["factions"] = {}
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_malformed_position_rejected(self):
        self.world["player"]["position"] = [0, 1]
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_claim_laundering_rejected(self):
        self.world["provenance"]["classification"] = "documented_history"
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_every_mission_stage_is_representable(self):
        events = ["accepted_errand", "collected_manifest", "delivered_manifest", "returned_to_contact"]
        for index, stage in enumerate(["available", "accepted", "collected", "delivered", "complete"]):
            with self.subTest(stage=stage):
                state = copy.deepcopy(self.world)
                state["mission"].update(stage=stage, has_manifest=stage == "collected")
                state["journal"] = events[:index]
                state["relationships"]["dock_contact"] = int(stage == "complete")
                validate_world(state)

    def test_journal_must_match_stage(self):
        self.world["journal"] = ["returned_to_contact"]
        with self.assertRaises(ValidationError): validate_world(self.world)

    def test_nonfinite_json_is_rejected(self):
        for value in ["NaN", "Infinity", "-Infinity", "1e999"]:
            with self.subTest(value=value), tempfile.TemporaryDirectory() as directory:
                path = Path(directory) / "bad.json"
                path.write_text('{"n":' + value + '}', encoding="utf-8")
                with self.assertRaises(ValueError): read_json(path)

    def test_snapshot_json_roundtrip(self):
        self.assertEqual(json.loads(json.dumps(self.world)), self.world)

    def test_readme_local_links_resolve(self):
        import re
        for target in re.findall(r'\]\(([^)]+)\)', (ROOT / "README.md").read_text(encoding="utf-8")):
            if "://" not in target and not target.startswith("#"):
                self.assertTrue((ROOT / target.split("#")[0]).exists(), target)


if __name__ == "__main__":
    unittest.main()
