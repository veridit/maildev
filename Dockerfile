FROM alpine:3.14
LABEL org.opencontainers.image.authors="Jørgen H. Fjeld <jorgen@veridit.no>"

RUN apk update \
  && apk add dumb-init \
  && apk add dovecot dovecot-pop3d dovecot-submissiond dovecot-lmtpd \
  && apk add exim exim-scripts exim-utils

# Avoid using encryption for docker setup.
RUN rm -f /etc/dovecot/conf.d/10-ssl.conf

# Add custom configuration file for submission (SMTP)
# with dovecot using the same username and password as
# for imap. This will forward to maildev.
COPY dovecot/11-custom-ssl.conf /etc/dovecot/conf.d/11-custom-ssl.conf
COPY dovecot/11-custom-auth.conf /etc/dovecot/conf.d/11-custom-auth.conf
COPY dovecot/auth-custom-static.conf.ext /etc/dovecot/conf.d/auth-custom-static.conf.ext
COPY dovecot/11-custom-logging.conf /etc/dovecot/conf.d/11-custom-logging.conf
COPY dovecot/20-submission.conf /etc/dovecot/conf.d/20-submission.conf
COPY dovecot/21-custom-lmtp.conf /etc/dovecot/conf.d/21-custom-lmtp.conf
# Add a hardcoded list of users with passwords for smtp and imap auth.
#COPY dovecot/users /etc/dovecot/users

COPY exim.conf /etc/exim/exim.conf

# Create a group and user
RUN adduser dev --gecos "Developer" --disabled-password
RUN echo "dev:secret" | chpasswd

# Initialize the Maildir directory with the required folders
# for Dovecot to recognize it as a valid Maildir directory.
RUN mkdir /home/dev/Maildir && \
  mkdir /home/dev/Maildir/cur && \
  mkdir /home/dev/Maildir/new && \
  mkdir /home/dev/Maildir/tmp && \
  chown -R dev /home/dev/Maildir

EXPOSE 80 25 110 143 587

COPY run.sh /run.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "/run.sh"]

HEALTHCHECK --interval=10s --timeout=1s \
  CMD wget -O - http://localhost:80/healthz || exit 1
