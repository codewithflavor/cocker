Name:           cocker
Version:        1.0.0
Release:        1%{?dist}
Summary:        Humorous Docker CLI wrapper with chicken-themed messages

License:        MIT
URL:            https://github.com/codewithflavor/cocker
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       bash
Requires:       docker

%description
Cocker is a humorous wrapper for the Docker CLI that adds ASCII chicken art
and random rooster-themed messages before executing Docker commands. It provides
the same functionality as docker while adding a fun twist to your container
management workflow.

%prep
%setup -c -n %{name}-%{version}

%build
# No build needed for bash scripts

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/bash-completion/completions

install -m755 bin/cocker %{buildroot}%{_bindir}/cocker
install -m644 completions/cocker.bash %{buildroot}%{_datadir}/bash-completion/completions/cocker

%files
%{_bindir}/cocker
%{_datadir}/bash-completion/completions/cocker

%changelog
* Fri Dec 05 2025 codewithflavor <codewithflavor@users.noreply.github.com> - 1.0.0-1
- Initial RPM release
- Added chicken-themed Docker wrapper
- Included bash completion support