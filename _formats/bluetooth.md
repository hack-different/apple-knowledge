# Bluetooth Services & UUIDs

Apple Bluetooth Low Energy (BLE) services, characteristics, and UUIDs.

## Constants

* **Apple Company Identifier**: `{{ site.data.bluetooth.constants.apple_id }}` (0x4C00)

## Low Energy Advertisements

<table>
    <thead>
    <tr>
        <th>Subtype</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.bluetooth.low_energy %}
    <tr>
        <td><code>{{ entry.subtype }}</code></td>
        <td>{{ entry.description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>

## UUIDs

{% include bluetooth_table.html %}
