FROM ubuntu:xenial
MAINTAINER Aris Prawisudatama <soedomoto@gmail.com>

# Change ubuntu mirror
RUN sed -i "s|http://archive.ubuntu.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|g" /etc/apt/sources.list
RUN apt-get update -y

# Install R
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y r-base r-base-dev libssl-dev libcurl3-dev curl

# Install Python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-dev python3-pip

# Install jupyter
RUN pip3 install --upgrade jupyter --no-cache-dir

# Install pandas numpy and scipy
RUN pip3 install --upgrade numpy scipy pandas --no-cache-dir

# Install R kernel
RUN Rscript -e "install.packages(c('repr', 'pbdZMQ', 'devtools'), repos='http://cran.us.r-project.org')"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel')"
RUN Rscript -e "IRkernel::installspec()"

# Clean apt cache
RUN DEBIAN_FRONTEND=noninteractive apt-get clean

# Create workdir and expose as volume
RUN mkdir -p /workdir
WORKDIR /workdir
VOLUME /workdir

#
ENTRYPOINT ["/usr/local/bin/jupyter", "notebook", "--allow-root", "--ip=0.0.0.0"]
