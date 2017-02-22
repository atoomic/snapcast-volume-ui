
all: install

install: 
	[ -e snapcast-ui.service ] || ( echo "Adjust snapcast-ui.service file"; cp snapcast-ui.service.example snapcast-ui.service )
        install snapcast-ui.conf /etc/default/
	install snapcast-ui.service /usr/lib/systemd/system/
	systemctl daemon-reload
	systemctl restart snapcast-ui.service
	systemctl status snapcast-ui.service
