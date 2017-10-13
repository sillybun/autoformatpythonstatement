import unittest
import autoformatpythonstatement as sut


@unittest.skip("Don't forget to test!")
class AutoformatpythonstatementTests(unittest.TestCase):

    def test_example_fail(self):
        result = sut.autoformatpythonstatement_example()
        self.assertEqual("Happy Hacking", result)
