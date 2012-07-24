Code.require_file "../../test_helper", __FILE__

defmodule OptionParser.SimpleTest do
  use ExUnit.Case, async: true

  test "parses boolean option" do
    assert OptionParser.Simple.parse(["--docs"]) == { [docs: true], [] }
  end

  test "parses alias boolean option" do
    assert OptionParser.Simple.parse(["-d"]) == { [d: true], [] }
  end

  test "parses alias boolean option as the alias key" do
    assert OptionParser.Simple.parse(["-d"], aliases: [d: :docs]) == { [docs: true], [] }
  end

  test "parses more than one boolean options" do
    assert OptionParser.Simple.parse(["--docs", "--compile"]) == { [docs: true, compile: true], [] }
  end

  test "parses more than one boolean options as the alias" do
    assert OptionParser.Simple.parse(["--d", "--compile"], aliases: [d: :docs]) == { [docs: true, compile: true], [] }
  end

  test "parses key/value option" do
    assert OptionParser.Simple.parse(["--source", "form_docs/"]) == { [source: "form_docs/"], [] }
  end

  test "parses alias key/value option" do
    assert OptionParser.Simple.parse(["-s", "from_docs/"]) == { [s: "from_docs/"], [] }
  end

  test "parses alias key/value option as the alias" do
    assert OptionParser.Simple.parse(["-s", "from_docs/"], aliases: [s: :source]) == { [source: "from_docs/"], [] }
  end

  test "parses key/value option when value is false" do
    assert OptionParser.Simple.parse(["--docs", "false"]) == { [docs: false], [] }
  end

  test "parses key/value option when value is true" do
    assert OptionParser.Simple.parse(["--docs", "true"]) == { [docs: true], [] }
  end

  test "parses more than one key/value options" do
    options = OptionParser.Simple.parse(["--source", "from_docs/", "--docs", "false"])
    assert options == { [docs: false, source: "from_docs/"], [] }
  end

  test "parses mixed options" do
    options = OptionParser.Simple.parse(["--source", "from_docs/", "--docs", "false", "--compile", "-x"])
    assert options == { [docs: false, source: "from_docs/", compile: true, x: true], [] }
  end

  test "stops on first non option arguments" do
    options = OptionParser.Simple.parse_head(["--source", "from_docs/", "test/enum_test.exs", "--verbose"])
    assert options == { [source: "from_docs/"], ["test/enum_test.exs", "--verbose"] }
  end

  test "goes beyond the first non option arguments" do
    options = OptionParser.Simple.parse(["--source", "from_docs/", "test/enum_test.exs", "--verbose"])
    assert options == { [source: "from_docs/", verbose: true], ["test/enum_test.exs"] }
  end
end
