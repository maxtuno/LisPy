"""
Entry point for python -m lisPy_kernel
"""
from .kernel import LisPyKernel

if __name__ == "__main__":
    from ipykernel.kernelapp import IPKernelApp
    IPKernelApp.launch_instance(kernel_class=LisPyKernel)
