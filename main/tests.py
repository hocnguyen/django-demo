from django.test import TestCase

from main.models import Subject


class AiAPITestBase(TestCase):

    def test_first(self):
        self.assertTrue(True)

    def test_create(self):
        Subject.create_subject(name="Create", order=1)
        subject = Subject.objects.count()
        self.assertIsNotNone(subject)
