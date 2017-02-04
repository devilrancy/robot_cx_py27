FROM python:2.7-slim

# Install Ubuntu packages
RUN apt-get update
RUN apt-get install alien dpkg-dev debhelper build-essential libaio1 --assume-yes

# Install oracle
# Reference: https://help.ubuntu.com/community/Oracle%20Instant%20Client
# Download RPM files from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#ADD oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm .
#ADD oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm .
#ADD oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm .

# Get Oracle Client (this isn't the offical download location, but at least it works without logging in!)
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
RUN curl -O http://repo.dlt.psu.edu/RHEL5Workstation/x86_64/RPMS/oracle-instantclient12.1-devel-12.1.0.1.0-1.x86_64.rpm

# Alien RPM package installer
RUN alien -i *.rpm

ADD oracle.conf /etc/ld.so.conf.d/oracle.conf
ADD oracle.sh /etc/profile.d/oracle.sh
RUN chmod o+r /etc/ld.so.conf.d/oracle.conf
RUN chmod o+r /etc/profile.d/oracle.sh

#RUN alien -i oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
#RUN alien -i oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
#RUN alien -i oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

RUN /etc/profile.d/oracle.sh
RUN ldconfig

#ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib

# Install python app
ADD test.py /code/
ADD docker_requirements.txt /code/
WORKDIR /code
RUN pip install -r docker_requirements.txt

RUN python test.py