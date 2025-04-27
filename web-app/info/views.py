from django.shortcuts import render
from django.views.generic import TemplateView
import socket
import platform
import subprocess
import os

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
        
        # Git commit information
        git_info = self.get_git_commit_info()
        context['git_commit'] = git_info['hash']
        context['git_message'] = git_info['message']
        
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
    
    def get_git_commit_info(self):
        """Get the current git commit hash and message"""
        result = {
            'hash': 'Git information unavailable',
            'message': 'No message available'
        }
        
        try:
            # Get the project root directory
            project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
            
            # Run git command to get the current commit hash
            hash_result = subprocess.check_output(
                ['git', 'rev-parse', 'HEAD'],
                cwd=project_root,
                stderr=subprocess.STDOUT
            ).decode('utf-8').strip()
            
            # Get a shorter version for display
            short_hash = hash_result[:8]
            result['hash'] = f"{short_hash} (full: {hash_result})"
            
            # Get the commit message
            message_result = subprocess.check_output(
                ['git', 'log', '-1', '--pretty=%B'],
                cwd=project_root,
                stderr=subprocess.STDOUT
            ).decode('utf-8').strip()
            
            result['message'] = message_result
            
            return result
        except subprocess.CalledProcessError:
            return result
        except Exception as e:
            result['hash'] = f"Error retrieving git info: {str(e)}"
            return result
