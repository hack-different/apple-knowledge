# Mach-O - Mach Object Files

Mach-O file types, header values, and segments.

## File Types

{% include mach_o_table.html %}

## Segments & Sections

<table>
    <thead>
    <tr>
        <th>Segment</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.mach_o.segments %}
    <tr>
        <td><code>{{ entry[0] }}</code></td>
        <td>{{ entry[1].description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
