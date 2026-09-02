# Image4 (IMG4) Format

The IMG4 format is used to package and verify Apple firmware binaries, manifests (IM4M), payloads (IM4P), and restore components.

## Core IMG4 Objects

<table>
    <thead>
    <tr>
        <th>Object</th>
        <th>Title</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.img4.core %}
    <tr>
        <td><code>{{ entry[0] }}</code></td>
        <td>{{ entry[1].title }}</td>
        <td>{{ entry[1].description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>

## Tags & Properties

{% include img4_table.html %}
