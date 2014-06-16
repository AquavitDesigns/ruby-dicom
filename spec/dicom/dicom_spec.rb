# encoding: UTF-8

require 'spec_helper'

module DICOM

  describe self do

    it "should have defined a default image processor" do
      expect(DICOM.image_processor).to eql :rmagick
    end

    it "should allow alternative image processors to be defined" do
      DICOM.image_processor = :mini_magick
      expect(DICOM.image_processor).to eql :mini_magick
    end


    context "#generate_uid" do

      it "should return a UID string" do
        uid = DICOM.generate_uid
        expect(uid).to be_a String
        expect(uid).to match /^[0-9]+([\\.]+|[0-9]+)*$/
      end

      it "should use the UID_ROOT constant when called without parameters" do
        uid = DICOM.generate_uid
        expect(uid.include?(UID_ROOT)).to be_truthy
        expect(uid.index(UID_ROOT)).to eql 0
      end

      it "should use the uid and prefix arguments, properly joined by dots" do
        root = "1.999"
        prefix = "6"
        uid = DICOM.generate_uid(root, prefix)
        expect(uid.include?("#{root}.#{prefix}.")).to be_truthy
      end

    end


    context "#load" do

      it "should raise an ArgumentError when a non-string/non-dcm is passed as an argument" do
        expect {DICOM.load(42.0)}.to raise_error(ArgumentError)
      end

      it "should return an empty array when given an invalid DICOM file path" do
        ary = DICOM.load('./invalid_file.dcm')
        expect(ary).to eql []
      end

      it "should return a DObject instance in an array when given a DICOM binary string" do
        str = File.open(DCM_ISO8859_1, "rb") { |f| f.read }
        ary = DICOM.load(str)
        expect(ary).to eql [DObject.parse(str)]
      end

      it "should return a DObject instance in an array when given a path to a DICOM file" do
        file = DCM_ISO8859_1
        ary = DICOM.load(file)
        expect(ary).to eql [DObject.read(file)]
      end

      it "should not set the DObject's :was_dcm_on_input attribute as true when given a path to a DICOM file" do
        file = DCM_ISO8859_1
        ary = DICOM.load(file)
        expect(ary.first.was_dcm_on_input).to be_falsey
      end

      it "should return the DObject instance in an array when given a DObject instance" do
        dcm = DObject.read(DCM_ISO8859_1)
        ary = DICOM.load(dcm)
        expect(ary).to eql [dcm]
      end

      it "should set the DObject's :was_dcm_on_input attribute as true when given a DObject instance" do
        dcm = DObject.read(DCM_ISO8859_1)
        ary = DICOM.load(dcm)
        expect(ary.first.was_dcm_on_input).to be_truthy
      end

      it "should return a DObject instance in an array when given an array with a DICOM binary string" do
        str = File.open(DCM_ISO8859_1, "rb") { |f| f.read }
        ary = DICOM.load([str])
        expect(ary).to eql [DObject.parse(str)]
      end

      it "should return a DObject instance in an array when given an array with a path to a DICOM file" do
        file = DCM_ISO8859_1
        ary = DICOM.load([file])
        expect(ary).to eql [DObject.read(file)]
      end

      it "should return the DObject instance in an array when given an array with a DObject instance" do
        dcm = DObject.read(DCM_ISO8859_1)
        ary = DICOM.load([dcm])
        expect(ary).to eql [dcm]
      end

      it "should return a one-element array with the valid DObject when given an array with one valid DICOM file path and one invalid file path" do
        ary = DICOM.load([DCM_ISO8859_1, './invalid_file.dcm'])
        expect(ary).to eql [DObject.read(DCM_ISO8859_1)]
      end

      it "should return an array with three DObject instance when given an array with a mix of DICOM file path, binary string and DObject instance" do
        file = DCM_ISO8859_1
        str = File.open(file, "rb") { |f| f.read }
        dcm = DObject.read(file)
        ary = DICOM.load([str, file, dcm])
        expect(ary).to eql [DObject.read(file), DObject.read(file), DObject.read(file)]
      end

      it "should return an array containing the expected DObject instances when given a directory (with sub-directories) which contains multiple DICOM files" do
        dir = DICOM::TMPDIR + 'load_files/'
        FileUtils.mkdir(dir)
        FileUtils.mkdir(dir + 'subdir/')
        FileUtils.mkdir(dir + 'subdir_empty/')
        FileUtils.copy_file(DCM_ISO8859_1, dir + File.basename(DCM_ISO8859_1))
        FileUtils.copy_file(DCM_AT_NO_VALUE, dir + 'subdir/' + File.basename(DCM_AT_NO_VALUE))
        ary = DICOM.load(dir)
        expect(ary).to eql [DObject.read(DCM_ISO8859_1), DObject.read(DCM_AT_NO_VALUE)]
      end

    end

  end
end