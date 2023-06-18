from django.urls import path

from emailapi import views


urlpatterns = [
    path('emails/', views.EmailList.as_view()),
    path('emails/<int:pk>/', views.EmailDetail.as_view()),
]
