$fn = 120;
$axis = [113.221504,112.959071];

function fix_vertices(vertices) =
    [ for (v = vertices) [(v[0] - $axis[0]), -(v[1] - $axis[1])] ];

module round(r) {
    offset(r) offset(-r) children();
}

function base_vertices() =
    fix_vertices([
        [210.138300,46.045947],
        [210.138300,79.383446],
        [210.138300,94.623446],
        [210.138300,120.817196],
        [193.96097,148.850465],
        [165.203622,132.247402],
        [114.908504,132.247197],
        [69.434875,140.26551],
        [52.688136,45.290036],
        [110.142436,35.159293],
        [189.659629,35.159293],
        [189.65963,46.045947]
    ]);

function screw_params() =
    let(
        vertices = base_vertices(),
        angles = [45, 0, 0, -30, -75, -105, -85, -125, 145, 95, 45]
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
        [49.817428, 56.4],
        [63.04942, 131.44],
        [203.086041, 142.56]
    ]);

function bolt_params() =
    let(
        positions = bolt_positions(),
        angles = [90, 190, 190, -30],
        rotation = [0, 100, 100, -120]
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
        [75.424471, 119.381909],
        [72.199173, 101.090336],
        [66.33649, 102.124086],
        [62.945792, 82.894483],
        [65.994389, 82.356933],
        [62.76909, 64.06536],
        [56.906406, 65.09911],
        [53.515708, 45.869507],
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
        [209.138300, 82.955321],
        [209.138300, 91.051571],
        [220.138300, 91.051571],
        [220.138300, 82.955321],
    ]));
}

module pre_trrs_plug_zone() {
    polygon(fix_vertices([
        [214.900879, 102.955321],
        [234.900879, 102.955321],
        [234.900879, 137.955321],
        [214.900879, 137.955321]
    ]));
}

module trrs_plug_zone() {
    polygon(fix_vertices([
        [214.900879, 82.955321],
        [234.900879, 82.955321],
        [234.900879, 137.955321],
        [214.900879, 137.955321]
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

//color("Teal", 0.75)
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
