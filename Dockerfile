# ==================================================================================
#  Copyright (c) 2020 HCL Technologies Limited.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ==================================================================================
#Python 3.11 miniconda
FROM continuumio/miniconda3:23.10.0-1

# sdl uses hiredis which needs gcc
RUN apt update && apt install -y gcc musl-dev vim

# RMR setup
RUN mkdir -p /opt/route/ /opt/ric/config /opt/id/src


# copy rmr libraries from builder image in lieu of an Alpine package
ARG RMRVERSION=4.9.4
RUN wget --content-disposition https://packagecloud.io/o-ran-sc/release/packages/debian/stretch/rmr_${RMRVERSION}_amd64.deb/download.deb && dpkg -i rmr_${RMRVERSION}_amd64.deb
RUN wget --content-disposition https://packagecloud.io/o-ran-sc/release/packages/debian/stretch/rmr-dev_${RMRVERSION}_amd64.deb/download.deb && dpkg -i rmr-dev_${RMRVERSION}_amd64.deb
RUN rm -f rmr_${RMRVERSION}_amd64.deb rmr-dev_${RMRVERSION}_amd64.deb

ENV LD_LIBRARY_PATH /usr/local/lib/:/usr/local/lib64
ENV C_INCLUDE_PATH /usr/local/include
COPY local.rt /opt/route/local.rt
ENV RMR_SEED_RT /opt/route/local.rt
ENV XAPP_CONFIG_PATH /opt/id/src/id_config.ini

# Install
COPY setup.py /tmp
COPY LICENSE.txt /tmp/
COPY xapp-descriptor/config.json /opt/ric/config
RUN pip install /tmp
RUN pip install tqdm
#RUN pip install ricxappframe
ENV PYTHONUNBUFFERED 1
ENV CONFIG_FILE /opt/ric/config/config-file.json

RUN mkdir -p /opt/id/src
COPY src/ /opt/id/src
WORKDIR /opt/id/src
CMD python main.py
