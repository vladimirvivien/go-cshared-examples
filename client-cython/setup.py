# -*- coding: utf-8 -*-
from setuptools import Extension, setup
from Cython.Build import cythonize

# because the name is not libawesome.so,
# ```extra_link_args``` is needed for gcc
# yet cgo only supports gcc,
ext_modules = [
    Extension("awesome",
              sources=["goawesome.pyx"],
              include_dirs=["."],
              library_dirs=["."],
              extra_link_args=["./awesome.so"],
              runtime_library_dirs=["."])]
setup(
    name='go',
    ext_modules=cythonize(ext_modules),
    zip_safe=False,
)
