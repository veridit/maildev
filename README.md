# Docker Email test system

Adds a SMTP and IMAP server to receive all mail and store it locally,
searchable with an IMAP interface.

## Install & Run

    $ docker run -p 1025:25 -p 1143:143 veridit/maildev

## IMAP and POP

To use IMAP and/or POP3, just point your prefered to Mail Client to

- host: `localhost`
- user: `user`
- password: `password`
- port:
  - 25 (SMTP)
  - 110 (POP3)
  - 143 (IMAP)

Make sure you disable any kind of encryption


## SMTP (Submission with Password)

To test authenticated submission from a command line, you can use the netcat command `nc`.
Here is an example usage:
```
nc localhost 1587 <<EOS
EHLO hostname
AUTH PLAIN AG5vZGUAcGFzc3dvcmQ=
MAIL FROM:<john@doe.com>
RCPT TO:<jane@doe.com>
DATA
From: John Doe <john@doe.com>
To: Jane Doe<jane@doe.com>
Date: Tue, 15 Jan 2008 16:02:43 -0500
Subject: Testing Authenticated SMTP submission

Find this email in the web interface at http://localhost:1080
and delete it.
.
QUIT
EOS
```

Notice that the `AUTH PLAIN` command uses the base encoded username and password,
generated with the command `echo -en "\0node\0password" | base64`.


## License

MIT
