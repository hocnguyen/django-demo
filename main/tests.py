from django.test import TestCase


class AiAPITestBase(TestCase):

    def test_first(self):
        self.assertTrue(True)

    def test_second(self):
        self.assertIsNotNone("test")
