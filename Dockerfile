# ##############################################################################
# # File: Dockerfile                                                           #
# # Project: postfix                                                           #
# # Created Date: 2024/11/24 11:59:24                                          #
# # Author: realjf                                                             #
# # -----                                                                      #
# # Last Modified: 2024/11/24 12:07:24                                         #
# # Modified By: realjf                                                        #
# # -----                                                                      #
# #                                                                            #
# ##############################################################################


FROM alpine:latest

ARG EMAIL
ARG EMAIL_PASSWORD
ARG MAIL_NAME
ARG SMTP_DOMAIN
ARG SMTP_PORT

# install postfix
RUN apt-get update && \
    apt-get install -y mailutils && \
    apt install -y postfix

COPY main.cf /etc/postfix/main.cf

RUN sh -c 'echo "root: ${EMAIL}" >> /etc/aliases' && \
    sh -c 'echo "${MAIL_NAME}" >> /etc/mailname' && \
    sh -c 'echo "[${SMTP_DOMAIN}]:${SMTP_PORT} ${EMAIL}:${EMAIL_PASSWORD}" >> /etc/postfix/sasl_passwd' && \
    postmap /etc/postfix/sasl_passwd && \
    chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

CMD service postfix restart && tail -f /dev/null
