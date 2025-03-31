Name:           cocker
Version:        1.0.0
Release:        1%{?dist}
Summary:        Alias for docker CLI tool with a chicken twist

License:        MIT
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

%description
Alias for docker CLI tool with a chicken twist

%prep
%autosetup

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
* Mon Mar 31 2025 Your Name <your.email@example.com> - 1.0.0-1
- Initial RPM release