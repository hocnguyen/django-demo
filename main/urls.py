from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('list/', views.list),
    path('create/', views.create),
    path('save/', views.create),
    path('save/<int:subject_id>/', views.update),
    path('update/<int:subject_id>/', views.update),
]