FROM python:3.8-bullseye

USER root

# Install Ansible v2.10+
RUN pip install --upgrade pip \
&& pip install ansible

CMD [ "tail", "-f", "/dev/null" ]
