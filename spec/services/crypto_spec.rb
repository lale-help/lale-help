require 'rails_helper'

describe Crypto do
  let(:string) { "This is a test string" }

  let(:encrypted) { Crypto::Encryptor.new.process(string) }

  it "can encrypt and decrypt things" do
    expect(encrypted.data).to_not eq(string)

    decrypted_string = Crypto::Decryptor.new(encrypted.details).process(encrypted.data)

    expect(decrypted_string).to eq(string)
  end

  it "cannot decrypt things with the wrong encryption details" do
    encrypted_string = Crypto::Encryptor.new.process(string).data
    wrong_details    = Crypto::Encryptor.new.process(string).details

    expect { Crypto::Decryptor.new(wrong_details).process(encrypted_string) }.to raise_error OpenSSL::Cipher::CipherError
  end

  context "encrypted.details" do
    it "has a the required information" do
      expect(encrypted.details[:cipher    ]).to be_present
      expect(encrypted.details[:key       ]).to be_present
      expect(encrypted.details[:iv        ]).to be_present
      expect(encrypted.details[:auth_data ]).to be_present
      expect(encrypted.details[:auth_tag  ]).to be_present
    end
  end
end