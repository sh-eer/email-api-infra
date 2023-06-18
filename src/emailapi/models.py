from django.db import models


class Email(models.Model):
    from_address = models.CharField(max_length=50)
    to_address = models.CharField(max_length=50)
    body = models.CharField(max_length=500)
