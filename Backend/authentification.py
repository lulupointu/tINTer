from functools import lru_cache

from flask_login import LoginManager
from ldap3 import Server, Connection, SUBTREE, ALL_ATTRIBUTES, Entry

# from utils.config import config
# from utils.models import LdapUser

login_manager = LoginManager()


# Pour ton info, dans la config du prog
ldap_provider = '127.0.0.1'
ldap_use_ssl = True
# au moins quand tu es sur place
# Sinon tu peux utiliser un pont ssh 
# sudo ssh -L 389:157.159.10.70:389 jovart_a@ssh1.imtbs-tsp.eu -i ./.ssh/id_rsa
# NB: il faut le sudo parceque je me bind a un port < 1024 sur mon ordi. Si tu veux un port au dessus, pas besoin de sudo.
# remplaces jovart_a par ton login, et le chemin vers ta clé ssh si besoin


server = Server(ldap_provider, use_ssl=ldap_use_ssl)


def func_authenticate(username, password, use_password=True):
    """
    Vérifie qu'un nom d'utilisateur et un mot de passe sont valides en authentifiant l'utilisateur avec le serveur LDAP de l'école.
    """
    if "@" in username:
        # L'username est peut etre un mail...
        maybe_username = get_login_from_email(username)
        if maybe_username:
            username = maybe_username

    if use_password:
        conn = Connection(server, user='uid={},ou=People,dc=int-evry,dc=fr'.format(username), password=password)
        if not conn.bind(("", 389)):
            return None
    else:
        conn = Connection(server, auto_bind=True)

    conn.search(u'ou=People,dc=int-evry,dc=fr', u"(uid={})".format(username), SUBTREE, attributes=ALL_ATTRIBUTES)

    try:
        res = conn.entries[0]
    except IndexError:
        return None

    return {"mail": str(res["mail"]), "display_name": str(res["givenName"]) + " " + str(res["sn"]), "first_name": str(res["givenName"]), "last_name": str(res["sn"])}


def get_login_from_email(email):
    conn = Connection(server, auto_bind=True)
    conn.search(u'ou=People,dc=int-evry,dc=fr', u"(mail={})".format(email), SUBTREE, attributes=["uid"])
    try:
        res = conn.entries[0]
    except IndexError:
        return None

    return str(res["uid"])


def delist(student):
    """
    Remove the stupid lists that ldap adds to the single dict attributes
    """
    new_student = {}

    for key, value in student.items():
        if isinstance(value, list):
            if len(value) == 1:
                new_student[key] = value[0]
            elif len(value) == 0:
                new_student[key] = ""
            else:
                new_student[key] = value
        else:
            new_student[key] = value
    return new_student


@lru_cache()
def get_students():
    """
    Recupere l'ensemble des informations sur les étudiants depuis le serveur LDAP
    """
    conn = Connection(server, auto_bind=True)
    conn.search(u'ou=People,dc=int-evry,dc=fr', u"(uid=*)", SUBTREE, attributes=["mail", "givenName", "sn", "uid", "title"])
    entries = conn.entries
    parsed = []
    for entry in entries:
        entry: Entry
        entry_dict = entry.entry_attributes_as_dict

        if len(entry_dict['title']):
            title = entry_dict['title'][0]
        else:
            title = ''

        if title.lower().startswith("cl"):
            parsed.append(delist(entry_dict))
    return parsed


def get_profile_picture_url_from_login(login, height=40, width=40):
    return f"https://trombi.imtbs-tsp.eu/photo.php?uid={login}&h={height}&w={width}"
