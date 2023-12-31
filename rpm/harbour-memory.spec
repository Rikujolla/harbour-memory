Name:       harbour-memory

Summary:    Multiple player networked memory card game
Version:    0.1.4
Release:    1
License:    BSD
URL:        http://example.org/
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Memory card game application intented for multiple players with multiple devices on local network.

# This description section includes metadata for SailfishOS:Chum, see
# https://github.com/sailfishos-chum/main/blob/main/Metadata.md
%if 0%{?_chum}
Title: Memory card game
Type: desktop-application
DeveloperName: Riku Lahtinen
Categories:
 - Games
Custom:
  Repo: https://github.com/Rikujolla/harbour-memory
PackageIcon: https://github.com/Rikujolla/harbour-memory/raw/main/harbour-memory.png
Screenshots:
 - https://github.com/Rikujolla/harbour-memory/raw/main/screenshots/screenshot1.png
 - https://github.com/Rikujolla/harbour-memory/raw/main/screenshots/screenshot2.png
 - https://github.com/Rikujolla/harbour-memory/raw/main/screenshots/screenshot3.png
Links:
  Homepage: https://github.com/Rikujolla/harbour-memory
  Help: https://github.com/Rikujolla/harbour-memory/discussions
  Bugtracker: https://github.com/Rikujolla/harbour-memory/issues
  Donation:
%endif


%prep
%setup -q -n %{name}-%{version}

%build

%qmake5 

%make_build


%install
%qmake5_install


desktop-file-install --delete-original         --dir %{buildroot}%{_datadir}/applications                %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
