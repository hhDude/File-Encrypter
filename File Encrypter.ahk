#singleinstance force
#include Lib/crypt.ahk
#include Lib/cryptconst.ahk
#include Lib/cryptfoos.ahk
global ealg
global halg

gui main:new, , File Encrypter
gui main:font, , Verdana
gui main:add, text, section xm ym, Encryption Algorithm 
gui main:add, dropdownlist, xp y+m wp r7 vealg altsubmit, RC4|RC2|3DES|3DES_112|AES_128|AES_192|AES_256||
gui main:add, text, center ys wp, Hashing Algorithm 
gui main:add, dropdownlist, xp y+m wp r6 vhalg altsubmit, MD5|MD2|SHA|SHA_256|SHA_384|SHA_512||
gui main:add, button, wp xm y+10 hwndencryptfiles, Encrypt`nFiles
gui main:add, button, wp x+m hwnddecryptfiles, Decrypt`nFiles
encrypt := func("crypt").bind(1)
decrypt := func("crypt").bind(0)
guicontrol +g, % encryptfiles, % encrypt
guicontrol +g, % decryptfiles, % decrypt
gui main:show

crypt(state, directory := "") {
    gui main:submit, nohide
    fileselectfile, files, m, % directory, % (state ? "Encryption" : "Decryption") " Selection"
    if errorlevel
        return
    array := strsplit(files, "`n", "`r")
    fromdir := array.removeat(1) "\"
    cryptdir := fromdir (state ? "Encrypted" : "Decrypted") "\"
    inputbox, pass, Password, % "Enter " (state ? "an encryption password.`n`nREMEMBER THIS PASSWORD.`nIT IS CHARACTER AND CASE SENSITIVE." : "the decryption password.")
    if errorlevel
        return
    if !fileexist(cryptdir)
        filecreatedir % cryptdir
    bytes := 0
    for k, v in array
        bytes += state ? crypt.encrypt.fileencrypt(fromdir v, cryptdir v, pass, ealg, halg) : crypt.encrypt.filedecrypt(fromdir v, cryptdir v, pass, ealg, halg)
    traytip, % "Finished " (state ? "Encrypting" : "Decrypting"), % bytes " bytes " (state ? "Encrypted" : "Decrypted") " and written to disk.",, 33
}

mainguiclose() {
    exitapp
}
