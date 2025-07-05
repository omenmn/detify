import dbus
import os
import sys

user = os.path.expanduser('~')


def get_song_url():
    try:
        # Connect to the session bus
        bus = dbus.SessionBus()

        # Iterate through potential MPRIS services
        for service in bus.list_names():
            if service.startswith("org.mpris.MediaPlayer2."):
                try:
                    player = dbus.SessionBus().get_object(
                        service, "/org/mpris/MediaPlayer2"
                    )

                    properties_interface = dbus.Interface(
                        player, "org.freedesktop.DBus.Properties"
                    )

                    # Get playback status
                    playback_status = properties_interface.Get(
                        "org.mpris.MediaPlayer2.Player", "PlaybackStatus"
                    )

                    if playback_status == "Playing" or playback_status == "Paused":
                        metadata = properties_interface.Get(
                            "org.mpris.MediaPlayer2.Player", "Metadata"
                        )

                        url = metadata.get('xesam:url', "")

                        return url
                except dbus.exceptions.DBusException:
                    continue
        return ""

    except dbus.exceptions.DBusException as e:
        return f"Error connecting to D-Bus: {e}"


def get_song_name():
    try:
        # Connect to the session bus
        bus = dbus.SessionBus()

        # Iterate through potential MPRIS services
        for service in bus.list_names():
            if service.startswith("org.mpris.MediaPlayer2."):
                try:
                    player = dbus.SessionBus().get_object(
                        service, "/org/mpris/MediaPlayer2"
                    )

                    properties_interface = dbus.Interface(
                        player, "org.freedesktop.DBus.Properties"
                    )

                    # Get playback status
                    playback_status = properties_interface.Get(
                        "org.mpris.MediaPlayer2.Player", "PlaybackStatus"
                    )

                    if playback_status == "Playing" or playback_status == "Paused":
                        metadata = properties_interface.Get(
                            "org.mpris.MediaPlayer2.Player", "Metadata"
                        )

                        name = metadata.get('xesam:title', "")

                        return name
                except dbus.exceptions.DBusException:
                    continue
        return ""

    except dbus.exceptions.DBusException as e:
        return f"Error connecting to D-Bus: {e}"


def get_downloaded_songs():
    music_path = f"{user}/Music"

    files = os.listdir(music_path)

    return files


def strip_list_to_name(files: list[str]):
    files = [s.split('- ')[1] for s in files]

    return files


def check_song_exists():
    files = get_downloaded_songs()
    names = strip_list_to_name(files)

    current_playing = f"{get_song_name()}.mp3"

    if current_playing in names:
        return True
    else:
        return False


if __name__ == "__main__":
    if (sys.argv.__len__() > 1):
        if (sys.argv[1] == 'check'):
            print(check_song_exists())
            exit()
    if check_song_exists():
        exit()
    else:
        print(get_song_url())
