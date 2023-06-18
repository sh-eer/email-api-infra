from rest_framework import generics

from emailapi.models import Email
from emailapi.serializers import EmailSerializer


class EmailList(generics.ListCreateAPIView):
    queryset = Email.objects.all()
    serializer_class = EmailSerializer


class EmailDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Email.objects.all()
    serializer_class = EmailSerializer
