# FROM tensorflow/tensorflow:nightly-py3-jupyter 
#LABEL maintainer Kiyoshi Fujine <wisteriaroots429@gmail.com>
#
#RUN apt-get update && apt-get install -y --no-install-recommends \
#    git
#
#RUN pip install jupyter_contrib_nbextensions
#RUN jupyter contrib nbextension install --user
#RUN mkdir -p $(jupyter --data-dir)/nbextensions
#
#RUN git clone https://github.com/lambdalisue/jupyter-vim-binding $(jupyter --data-dir)/nbextensions/vim_binding
#RUN jupyter nbextension enable vim_binding/vim_binding
#
#RUN pip install \
#    keras
#
#CMD ["/bin/bash"]

FROM ubuntu

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
build-essential \
curl \
git \
graphviz \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

RUN curl -qsSLkO \
https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-`uname -p`.sh \
&& bash Miniconda3-latest-Linux-`uname -p`.sh -b \
&& rm Miniconda3-latest-Linux-`uname -p`.sh

ENV PATH=/root/miniconda3/bin:$PATH

RUN conda install -y \
h5py \
numpy \
pandas \
keras \
tensorflow \
pydot \
jupyter \
matplotlib \
seaborn \
pillow \
&& conda clean --yes --tarballs --packages --source-cache


RUN pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --user
RUN mkdir -p $(jupyter --data-dir)/nbextensions

RUN git clone https://github.com/lambdalisue/jupyter-vim-binding.git $(jupyter --data-dir)/nbextensions/vim_binding
RUN jupyter nbextension enable vim_binding/vim_binding

RUN pip install tensorflow-hub

VOLUME /notebook
WORKDIR /notebook
EXPOSE 8888
CMD jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --NotebookApp.allow_origin='*'
