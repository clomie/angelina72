$fn = 120;
$axis = [113.221504,112.959071];

function fix_vertices(vertices) =
    [ for (v = vertices) [(v[0] - $axis[0]), -(v[1] - $axis[1])] ];

module round(r) {
    offset(r) offset(-r) children();
}

function base_vertices() =
    fix_vertices([
        [210.138300, 46.045947],
        [210.138300, 77.633446],
        [210.138300, 92.873446],
        [210.138300, 120.817196],
        [193.96097, 148.850465],
        [165.203622, 132.247402],
        [114.908504, 132.247197],
        [69.434875, 140.26551],
        [45.86305, 112.173703],
        [34.631071, 48.473983],
        [110.142436, 35.159293],
        [189.659629, 35.159293],
        [189.65963, 46.045947]
    ]);

function screw_params() =
    let(
        vertices = base_vertices(),
        angles = [45, 30, -30, -30, -75, -105, -85, -125, 195, 145, 95, 45]
    )
    [ for (i = [0 : len(angles) - 1]) 
        [
            vertices[i],
            [ cos(angles[i]), sin(angles[i]) ]
        ]
    ];

module base() {
    union() {
        polygon(base_vertices());
        pre_usb_padding();
    }
}

module screw_hole(offset_width, hole_size) {
    for(p = screw_params()) {
        let(
            d = offset_width - 2,
            x = p[0][0] + p[1][0] * d,
            y = p[0][1] + p[1][1] * d
        )
        translate([x, y]) circle(hole_size);
    }
}

module bolt_tab_shape(offset) {
    let(
        r = 4.6,
        ro = r + offset,
        r2 = r / 2
    )
    difference() {
        union() {
            circle(ro);
            polygon([
                [-ro, 0],
                [ ro, 0],
                [ ro,                 -(r2 + 0.1625) + offset],
                [ ro + (r2 + 0.1625), -( r + 0.1625) + offset],
                [-ro - (r2 + 0.1625), -( r + 0.1625) + offset],
                [-ro,                 -(r2 + 0.1625) + offset]
            ]);
        };
        circle(2.6);
        translate([ (ro + r2), -(r2 + 0.1625) + offset]) circle(r2);
        translate([-(ro + r2), -(r2 + 0.1625) + offset]) circle(r2);
    }
}

function bolt_positions() = 
    fix_vertices([
        [179.658379, 30.41],
        [31.761323, 59.619306],
        [56.761091, 132.570123],
        [203.086041, 142.56]
    ]);

function bolt_params() =
    let(
        positions = bolt_positions(),
        angles = [90, 190, 220, -30],
        rotation = [0, 100, 130, -120]
    )
    [ for (i = [0 : len(angles) - 1])
        [
            positions[i],
            [ cos(angles[i]), sin(angles[i]) ],
            rotation[i]
        ]
    ];

module bolt_tabs(level) {
    let(o = calc_offset(level) - calc_offset(3))
    for(p = bolt_params()) {
        let(
            d = calc_bezel_width(3),
            x = p[0][0] + p[1][0] * d,
            y = p[0][1] + p[1][1] * d
        )
        translate([x, y]) rotate(p[2]) bolt_tab_shape(o);
    }
}

module pcb_shape() {
    round(0.5) round(-0.5)
    polygon(fix_vertices([
        [110.382504, 36.520946],
        [189.65963, 36.520946],
        [189.65963, 46.045947],
        [210.138379, 46.045947],
        [210.138223, 113.646389],
        [213.249095, 115.442451],
        [193.96097, 148.850464],
        [165.203622, 132.247401],
        [114.908504, 132.247196],
        [69.434875, 140.265509],
        [66.044177, 121.035908],
        [56.746584, 123.158922],
        [53.438586, 104.398334],
        [47.575902, 105.432083],
        [44.185204, 86.202481],
        [47.2338, 85.664931],
        [44.008502, 67.373358],
        [38.145818, 68.407108],
        [34.755121, 49.177505],
        [91.036884, 39.253512],
        [90.912834, 38.549991],
        [110.142436, 35.159292]
    ]));
}

module usb_notch() {
    polygon(fix_vertices([
        [206.804629, 46.045947],
        [193.945879, 46.045947],
        [193.945879, 16.045947],
        [206.804629, 16.045947],
    ]));
}

module pre_usb_padding() {
    polygon(fix_vertices([
        [192.804629, 46.045947],
        [189.659629, 46.045947],
        [189.659629, 35.159293],
        [192.804629, 35.159293],
    ]));
}

module trrs_notch() {
    polygon(fix_vertices([
        [215.377129, 89.301571],
        [209.424004, 89.301571],
        [209.424004, 81.205321],
        [215.377129, 81.205321]
    ]));
}

module pre_trrs_plug_zone() {
    polygon(fix_vertices([
        [214.900879, 102.205321],
        [225.140254, 102.205321],
        [225.140257, 137.402821],
        [214.900882, 137.402821]
    ]));
}

module trrs_plug_zone() {
    polygon(fix_vertices([
        [214.900879, 81.205321],
        [225.140254, 81.205321],
        [225.140257, 137.402821],
        [214.900882, 137.402821]
    ]));
}

$base_bezel_width = (214.900879-210.138300);
$base_round_r = 2;
$max_level = 4;
$offset_config = [0, 1.5, 1.5, 1.1, 0.7];

function calc_offset(level) =
    $offset_config[level] + (level == 0 ? 0 : calc_offset(level - 1));

function calc_bezel_width(level) = 
    $base_bezel_width + calc_offset(level);

function calc_round_r(level) =
    $base_round_r + calc_offset(level);

module layer(level) {
    let(
        bezel_width = calc_bezel_width(level),
        round_convex = calc_round_r(level),
        round_concave = calc_round_r($max_level - level)
    )
    union() {
        echo(str("  level = ", level,
                 ", bezel_width = ", bezel_width,
                 ", round_convex = ", round_convex,
                 ", round_concave = ", round_concave
        ));
        round(round_convex)
        round(-round_concave)
        difference() {
            offset(delta = bezel_width) children();
            pre_trrs_plug_zone();
        }
    };
}

module bottom(level) {
    round(0.5) round(-0.5)
    difference() {
        layer(level) base();
        translate([0, calc_bezel_width(level), 0]) usb_notch();
        trrs_plug_zone();
    }
}

module middle(level) {
    round(0.5) round(-0.5) 
    difference() {
        layer(level) base();
        usb_notch();
        trrs_notch();
        trrs_plug_zone();
        pcb_shape();
    }
}

module top(level) {
    difference() {
        bottom(level);
        pcb_shape();
    }
}

module with_screw(r) {
    difference() {
        children();
        screw_hole($base_bezel_width, r);
    }
}

module with_bolt_tab(level) {
    union() {
        children();
        bolt_tabs(level);
    }
}

$layer_thickness = [2, 2, 2, 2, 3, 2, 2, 2];
$z_span = 0;
function calc_z_pos(index) =
    let(i = index - 1)
    index == 0 ? 0 : $layer_thickness[i] + $z_span + calc_z_pos(i);

module plate(index) {
    translate([0, 0, calc_z_pos(index)])
    linear_extrude($layer_thickness[index])
    children();
}

color("Teal", 0.75)
mirror([1, 0, 0])
rotate([0, 0, -10]) {
    plate(0) with_screw(1)   bottom(0);
    plate(1) with_screw(1)   top(1);
    plate(2) with_screw(1)   middle(2);
    plate(3) with_screw(1.5) with_bolt_tab(3) middle(3);
    plate(4) with_screw(1.5) with_bolt_tab(4) middle(4);
    plate(5) with_screw(1.5) with_bolt_tab(3) middle(3);
    plate(6) with_screw(1)   top(2);
    plate(7) with_screw(1)   top(1);
}
