from django.db import models


class Subject(models.Model):
    name = models.CharField(max_length=30)
    order = models.IntegerField()

    def create_subject(name, order):
        Subject.objects.create(name=name, order=order)