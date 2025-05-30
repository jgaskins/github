require "base64"
require "file_utils"
require "./error"

module GitHub
  # :nodoc:
  # This module exists for determining whether a private key input is the literal
  # key as a string, a base64-encoded version of the key, or a path to either of
  # those. This allows for flexibility in passing a GitHub app's private key in
  # different deployment environments.
  module PrivateKey
    # Represents the identified type of the input string.
    enum Type
      PemKeyContent               # Input string is directly a PEM-formatted key
      Base64KeyContent            # Input string is directly a base64-encoded key
      FilePathToPemKey            # Input is a path to a file containing a PEM key
      FilePathToBase64Key         # Input is a path to a file containing a base64 key
      FilePathUnrecognizedContent # Input is a path to a file, but content is not a recognized key format
      FilePathDoesNotExist        # Input looks like a path, but the file does not exist
      FilePathReadError           # Input is a path, file exists, but couldn't be read
      UnknownFormat               # Format could not be determined
    end

    class LoadError < Error
    end

    def self.load(input : String) : String
      load?(input) || raise LoadError.new("Cannot infer a private key from #{input.inspect}")
    end

    # Loads the key for the input - literal, base64-encoded literal, path to a
    # key, path to a base64-encoded key, etc.
    def self.load?(input : String) : String?
      case identified = identify(input)
      in .pem_key_content?
        input
      in .base64_key_content?
        Base64.decode_string input.tr(" \n\t", "")
      in .file_path_to_pem_key?
        File.read(input)
      in .file_path_to_base64_key?
        Base64.decode_string File.read input
      in .file_path_unrecognized_content?, .file_path_does_not_exist?, .file_path_read_error?, .unknown_format?
        nil
      end
    end

    # Identifies the type of the input string.
    def self.identify(input : String) : Type
      stripped_input = input.strip # Use stripped for path checks and some content checks

      # 1. Is the input string directly a PEM-formatted key?
      #    Check input because PEM format includes newlines.
      return Type::PemKeyContent if is_pem_key?(input)

      # 2. Could the input string be a file path to an existing file?
      #    Use stripped_input for file operations.
      if File.exists?(stripped_input)
        begin
          file_content = File.read(stripped_input)
          if is_pem_key?(file_content)
            return Type::FilePathToPemKey
            # Check stripped file content for base64, as it might have its own whitespace.
          elsif is_plausible_base64_key_content?(file_content.strip)
            return Type::FilePathToBase64Key
          else
            return Type::FilePathUnrecognizedContent
          end
        rescue ex : IO::Error
          # Optionally log the error: STDERR.puts "Error reading file #{stripped_input}: #{ex.message}"
          return Type::FilePathReadError
        end
      else
        # File does NOT exist at the given path.
        # Now, the input string itself (if not PEM) could be:
        # a) A base64 encoded key.
        # b) A path string for a non-existent file.
        # c) Something else (unknown).

        # Check if the stripped_input itself is plausible base64 content.
        if is_plausible_base64_key_content?(stripped_input)
          return Type::Base64KeyContent
        end

        # If not PEM, not an existing file, and not plausible base64 itself,
        # but it *did* look like a path pattern, classify as a non-existent path.
        if possible_path_pattern?(stripped_input)
          return Type::FilePathDoesNotExist
        end
      end

      # 3. If none of the above, it's an unknown format.
      return Type::UnknownFormat
    end

    private def self.is_pem_key?(text : String) : Bool
      text = text.strip

      # Common PEM headers for private keys
      prefixes = [
        "-----BEGIN PRIVATE KEY-----",
        "-----BEGIN RSA PRIVATE KEY-----",
        "-----BEGIN EC PRIVATE KEY-----",
        "-----BEGIN OPENSSH PRIVATE KEY-----",
        "-----BEGIN DSA PRIVATE KEY-----",
        "-----BEGIN ENCRYPTED PRIVATE KEY-----",
        "-----BEGIN PKCS8ENCRYPTED PRIVATE KEY-----",
      ]
      # Corresponding PEM footers
      suffixes = [
        "-----END PRIVATE KEY-----",
        "-----END RSA PRIVATE KEY-----",
        "-----END EC PRIVATE KEY-----",
        "-----END OPENSSH PRIVATE KEY-----",
        "-----END DSA PRIVATE KEY-----",
        "-----END ENCRYPTED PRIVATE KEY-----",
        "-----END PKCS8ENCRYPTED PRIVATE KEY-----",
      ]

      matched_prefix = prefixes.find { |p| text.starts_with?(p) }
      return false if matched_prefix.nil?

      matched_suffix = suffixes.find { |suf| text.ends_with?(suf) }
      return false if matched_suffix.nil?

      # Ensure there's at least one line of non-whitespace content between the
      # header and footer
      if text.size > matched_prefix.size + matched_suffix.size && text.includes?('\n')
        content_part = text[matched_prefix.size...-matched_suffix.size].strip
        return !content_part.empty?
      end

      false
    end

    # Assumes it's not already identified as PEM.
    private def self.is_plausible_base64_key_content?(text : String) : Bool
      # Content might be copy-pasted, so we remove whitespace (newlines, spaces,
      # tabs) that may have been accidentally copied.
      text = text.tr(" \n\t", "")
      return false if text.empty?

      # Base64 will only have A-Z, a-z, 0-9, +, and / characters, and may end
      # with `=`.
      return false if text.rstrip('=').match(/[^A-Za-z0-9+\/]/)

      # Validate padding: max two '=' and only at the end.
      padding_size = text.count('=')
      return false if padding_size > 2 || !text.ends_with?("=" * padding_size)

      # The ultimate test is if Base64.decode succeeds and yields a PEM key
      begin
        is_pem_key? Base64.decode_string(text)
        # Base64.decode_string(text).bytesize >= 16
      rescue ArgumentError # invalid Base64 (chars, size, padding)
        false
      end
    end

    private def self.possible_path_pattern?(text : String) : Bool
      return true if text.includes?('/') || text.includes?('\\') # Common separators
      return true if text.starts_with?(".")                      # ./file or ../file or .file (hidden file)
      return true if text.starts_with?("~")                      # ~/file (home directory)
      return true if text.match(/^[a-zA-Z]:\\/)                  # Windows drive letter C:\
      # Ends with some common extensions that might indicate a key file
      return true if text.match(/\.(pem|key|p8|pkcs1|pkcs8|der)$/i)
      false
    end
  end
end
