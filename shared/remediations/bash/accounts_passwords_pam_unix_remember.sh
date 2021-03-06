. /usr/share/scap-security-guide/remediation_functions
populate var_accounts_passwords_pam_unix_remember

if grep -q "remember=" /etc/pam.d/system-auth; then
        sed -i --follow-symlinks "s/\(remember *= *\).*/\1$var_accounts_passwords_pam_unix_remember/" /etc/pam.d/system-auth
else
        sed -i --follow-symlinks "/pam_unix.so/ s/$/ remember=$var_accounts_passwords_pam_unix_remember/" /etc/pam.d/system-auth
fi
