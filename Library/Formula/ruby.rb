require 'formula'

# TODO de-version the include and lib directories

class Ruby <Formula
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p378.tar.gz'
  homepage 'http://www.ruby-lang.org/en/'
  head 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_9_2/', :using => :svn
  md5 '9fc5941bda150ac0a33b299e1e53654c'

  depends_on 'readline'

  def options
    [
      ["--with-suffix", "Add a 19 suffix to commands"],
      ["--with-doc", "Install with the Ruby documentation"],
    ]
  end

  # Stripping breaks dynamic linking
  skip_clean :all

  def install
    fails_with_llvm

    args = [ "--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--enable-shared" ]

    args << "--program-suffix=19" if ARGV.include? "--with-suffix"

    system "autoconf" unless File.exists? 'configure'

    system "./configure", *args
    system "make"
    system "make install"

    system "make install-doc" if ARGV.include? "--with-doc"
  end

  def caveats; <<-EOS.undent
    Consider using RVM or Cider to manage Ruby environments:
      * RVM: http://rvm.beginrescueend.com/
      * Cider: http://www.atmos.org/cider/intro.html

    If you install gems with the RubyGems installed with this formula they will
    be installed to this formula's prefix. This needs to be fixed, as for example,
    upgrading Ruby will lose all your gems.
    EOS
  end
end
