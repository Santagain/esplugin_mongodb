resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
name "Mongo Bridge - Essentialmode"
description "Bridge de Eventos MongoDB"
author "Dione B."
version "1.0"

dependencies {
	'DatabaseAPI',
}

server_scripts {
	'server.lua'
}
