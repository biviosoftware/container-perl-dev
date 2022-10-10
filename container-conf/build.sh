#!/bin/bash
build_image_base=centos:7
build_is_public=1
build_maintainer="Bivio Software <$build_type@bivio.biz>"
# Perl and apps are installed globally so don't want a local
# library conflicting.
export BIVIO_WANT_PERL=

build_as_root() {
    install_repo_as_root biviosoftware/container-perl base
    install_yum_install "$(install_foss_server)"/bivio-perl-dev.rpm
}

build_as_run_user() {
    mkdir -p ~/bconf.d
cat > ~/bconf.d/defaults.bconf <<'EOF'
{
    'Bivio::Die' => {
#       stack_trace_error => 1,
#       stack_trace => 1,
    },
    'Bivio::IO::Alert' => {
#       stack_trace_warn => 1,
#       stack_trace_warn_deprecated => 1,
        max_arg_length => 1000000,
        max_element_count => 100,
        max_arg_depth => 5,
    },
    'Bivio::Biz::Action::AssertClient' => {
#       hosts => [qw()],
    },
    'Bivio::Test::Language::HTTP' => {
        mail_tries => 5,
    },
    'Bivio::IO::Trace' => {
#       command_line_arg => '/sql|ec/i',
#       package_filter => '/Agent|Task|Model/',
#       call_filter => '!grep(/Can.t locate/, @$msg)',
    },
};
EOF
}
