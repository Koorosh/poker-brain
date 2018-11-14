FROM tensorflow/tensorflow

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y python-pil python-lxml python-tk wget git-all python-dev python-pip && \
    pip install --user Cython && \
    pip install --user contextlib2 && \
    pip install --user jupyter && \
    pip install --user matplotlib

RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip && \
    unzip protoc-3.6.1-linux-x86_64.zip -d /usr/local bin/protoc && \
    rm -f protoc-3.6.1-linux-x86_64.zip

RUN mkdir -p /tensorflow/models && \
    git clone https://github.com/tensorflow/models.git /tensorflow/models

RUN git clone https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make && \
    python setup.py install && \
    cp -r pycocotools /tensorflow/models/research/

WORKDIR /tensorflow/models/research

RUN protoc object_detection/protos/*.proto --python_out=. && \
    export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

RUN python setup.py build && \
    python setup.py install

ENV PYTHONPATH="${PYTHONPATH}:/tensorflow/models/research:/tensorflow/models/research/slim"

EXPOSE 8888
EXPOSE 6006

CMD ["/run_jupyter.sh", "--allow-root"]