# typed: false
# frozen_string_literal: true

all
exclude_tag :line_length
exclude_rule 'fenced-code-language' # Fenced code blocks should have a language
rule 'MD013', line_length: 120, ignore_code_blocks: false, code_blocks: false, tables: false
