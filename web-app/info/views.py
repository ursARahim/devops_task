from django.shortcuts import render
from django.views.generic import TemplateView
import socket
import platform

# Create your views here.

class HostnameView(TemplateView):
    template_name = "info/hostname.html"
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        
        # Basic system information
        context['hostname'] = socket.gethostname()
        context['ip_address'] = self.get_ip_address()
        context['os_name'] = platform.system()
        context['os_version'] = platform.version()
        context['platform'] = platform.platform()
        context['processor'] = platform.processor()
        
        return context
    
    def get_ip_address(self):
        try:
            # This gets the primary external IP address
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip_address = s.getsockname()[0]
            s.close()
            return ip_address
        except:
            return "Unable to determine IP address"
