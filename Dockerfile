FROM ubuntu:latest

WORKDIR /installation

COPY install.sh .
COPY .installers/ ./.installers/ 

RUN chmod +x install.sh
RUN apt update && apt install -y sudo

CMD ["bash"]
