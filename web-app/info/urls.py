from django.urls import path
from .views import HostnameView

urlpatterns = [
    path('', HostnameView.as_view(), name='hostname'),
] 