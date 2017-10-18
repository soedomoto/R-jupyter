FROM alpine:edge
MAINTAINER Aris Prawisudatama <soedomoto@gmail.com>

RUN apk upgrade --update

# Install essential
RUN apk add --no-cache alpine-sdk libevent-dev bsd-compat-headers git

# Install Python
RUN apk add --no-cache python3 python3-dev
RUN python3 -m ensurepip && rm -r /usr/lib/python*/ensurepip
RUN pip3 install --upgrade pip setuptools

# Install jupyter
RUN pip3 install --upgrade jupyter ipyparallel --no-cache-dir
RUN ipcluster nbextension enable

# Install required packages
RUN apk add --no-cache autoconf automake libtool
RUN git clone -b 3.6.2 --single-branch https://git.osgeo.org/gogs/geos/geos.git
RUN cd geos && ./autogen.sh && ./configure && make && make install
RUN rm -R geos

RUN apk add --no-cache openblas openblas-dev \
  gfortran \
  freetype freetype-dev \
  libpng libpng-dev \
  libffi libffi-dev \
  openssl openssl-dev \
  libxml2 libxml2-dev \
  libxslt libxslt-dev \
  curl curl-dev \
  zeromq zeromq-dev

# Install required python packages
RUN pip3 install --upgrade --no-cache-dir numpy
RUN pip3 install --upgrade --no-cache-dir scipy
RUN pip3 install --upgrade --no-cache-dir pandas
RUN pip3 install --upgrade --no-cache-dir matplotlib
RUN pip3 install --upgrade --no-cache-dir seaborn
RUN pip3 install --upgrade --no-cache-dir bokeh
RUN pip3 install --upgrade --no-cache-dir networkx
RUN pip3 install --upgrade --no-cache-dir sklearn
RUN pip3 install --upgrade --no-cache-dir keras
RUN pip3 install --upgrade --no-cache-dir https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.3.0-cp36-cp36m-linux_x86_64.whl
RUN pip3 install --upgrade --no-cache-dir theano
RUN pip3 install --upgrade --no-cache-dir nltk
RUN pip3 install --upgrade --no-cache-dir gensim
RUN pip3 install --upgrade --no-cache-dir scrapy
RUN pip3 install --upgrade --no-cache-dir cython
RUN pip3 install --upgrade --no-cache-dir https://github.com/matplotlib/basemap/archive/v1.1.0.tar.gz
RUN pip3 install --upgrade --no-cache-dir https://github.com/statsmodels/statsmodels/archive/v0.8.0.tar.gz

# Install R
RUN apk add --no-cache R R-dev

# Install R kernel
RUN Rscript -e "install.packages(c('devtools'), repos='http://cran.r-project.org')"
RUN Rscript -e "devtools::install_github('IRkernel/repr')"
RUN Rscript -e "devtools::install_github('IRkernel/IRdisplay')"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel')"
RUN Rscript -e "IRkernel::installspec()"

# Install required R packages
RUN Rscript -e "install.packages(c('sqldf', 'forecast', 'plyr', 'dplyr', 'stringr', 'lubridate', 'ggplot2', 'ggrepel', 'ez', 'scales', 'qcc', 'reshape', 'reshape2', 'randomForest'), repos='http://cran.r-project.org')"

# Remove unused
RUN apk del --purge R-dev openssl-dev curl-dev freetype-dev libpng-dev libffi-dev libxml2-dev libxslt-dev zeromq-dev libevent-dev lapack-dev python3-dev autoconf automake libtool alpine-sdk bsd-compat-headers git
