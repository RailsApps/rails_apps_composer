Setup note for NetBSD:

On NetBSD (as of version 6.0), 'sed' lacks an -i option, so use 
package gsed instead:

(
  pkgin install gsed
  cd /usr/bin
  mv sed old-sed
  ln -s /usr/pkg/bin/gsed sed
  ls -ld *sed*
  sed --version | grep GNU || echo failed
)

If this worked, the word GNU should be printed at least once.
