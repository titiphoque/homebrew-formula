class ImagemagickLibrsvg < Formula
    desc "Tools and libraries to manipulate images in many formats"
    homepage "https://www.imagemagick.org/"
    # Please always keep the Homebrew mirror as the primary URL as the
    # ImageMagick site removes tarballs regularly which means we get issues
    # unnecessarily and older versions of the formula are broken.
    url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.1.0-4.tar.xz"
    mirror "https://www.imagemagick.org/download/ImageMagick-7.1.0-4.tar.xz"
    sha256 "1a54bd46947f16fb29cf083be3614a14135f2fe9d1aa20665a85a8940bf6dc65"
    head "https://github.com/ImageMagick/ImageMagick.git"
  
    depends_on "pkg-config" => :build
  
    depends_on "freetype"
    depends_on "jpeg"
    depends_on "libomp"
    depends_on "libpng"
    depends_on "librsvg"
    depends_on "libtiff"
    depends_on "libtool"
    depends_on "little-cms2"
    depends_on "openjpeg"
    depends_on "webp"
    depends_on "xz"
  
    skip_clean :la
  
    def install
      args = %W[
        --disable-osx-universal-binary
        --prefix=#{prefix}
        --disable-dependency-tracking
        --disable-silent-rules
        --disable-opencl
        --enable-shared
        --enable-static
        --with-freetype=yes
        --with-modules
        --with-openjp2
        --with-rsvg
        --with-webp=yes
        --without-gslib
        --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
        --without-fftw
        --without-pango
        --without-x
        --without-wmf
        --enable-openmp
        ac_cv_prog_c_openmp=-Xpreprocessor\ -fopenmp
        ac_cv_prog_cxx_openmp=-Xpreprocessor\ -fopenmp
        LDFLAGS=-lomp
      ]
  
      # versioned stuff in main tree is pointless for us
      inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
      system "./configure", *args
      system "make", "install"
    end
  
    test do
      assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
      # Check support for recommended features and delegates.
      features = shell_output("#{bin}/convert -version")
      %w[Modules freetype jpeg png tiff].each do |feature|
        assert_match feature, features
      end
    end
  end
  
