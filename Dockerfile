FROM ubuntu:xenial
MAINTAINER Aris Prawisudatama <soedomoto@gmail.com>

# Change ubuntu mirror
RUN sed -i "s|http://archive.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|g" /etc/apt/sources.list
RUN apt-get update -y

# Install Python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-dev python3-pip

# Install jupyter
RUN pip3 install --upgrade jupyter ipyparallel --no-cache-dir
RUN ipcluster nbextension enable

# Install required python packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgeos-dev
RUN pip3 install --upgrade numpy scipy pandas matplotlib seaborn bokeh networkx sklearn keras tensorflow theano nltk gensim scrapy --no-cache-dir
RUN pip3 install --upgrade cython
RUN pip3 install --upgrade https://github.com/matplotlib/basemap/archive/v1.1.0.tar.gz https://github.com/statsmodels/statsmodels/archive/v0.8.0.tar.gz --no-cache-dir

# Install R
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y r-base r-base-dev libssl-dev libcurl3-dev curl

# Install R kernel
RUN Rscript -e "install.packages(c('repr', 'pbdZMQ', 'devtools'), repos='http://cran.r-project.org')"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel')"
RUN Rscript -e "IRkernel::installspec()"

# Install required R packages
RUN Rscript -e "install.packages(c('sqldf', 'forecast', 'plyr', 'dplyr', 'stringr', 'lubridate', 'ggplot2', 'ggrepel', 'ez', 'qcc', 'reshape', 'reshape2', 'randomForest'), repos='http://cran.r-project.org')"

# Clean apt cache
RUN DEBIAN_FRONTEND=noninteractive apt-get clean

# Create workdir and expose as volume
RUN mkdir -p /workdir
WORKDIR /workdir
VOLUME /workdir

# Startup
EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/jupyter", "notebook", "--allow-root", "--ip=0.0.0.0"]
