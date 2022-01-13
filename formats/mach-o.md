# Mach-O - Mach Object Files

## Overview

Contains data about Mach-O file types, their load commands and other structured data

## Types

{% for type in data.mach-o.file_types %}

### {{ type }}

{{ data.mach_o.file_types[type].description }}
{% endfor %}

## Segments

TBD

## Commands

TBD