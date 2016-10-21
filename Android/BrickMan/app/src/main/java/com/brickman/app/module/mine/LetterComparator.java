package com.brickman.app.module.mine;

import com.brickman.app.model.Bean.CityBean;

import java.util.Comparator;

public class LetterComparator implements Comparator<CityBean> {

    @Override
    public int compare(CityBean l, CityBean r) {
        if (l == null || r == null) {
            return 0;
        }

        String lhsSortLetters = l.pys.substring(0, 1).toUpperCase();
        String rhsSortLetters = r.pys.substring(0, 1).toUpperCase();
        if (lhsSortLetters == null || rhsSortLetters == null) {
            return 0;
        }
        return lhsSortLetters.compareTo(rhsSortLetters);
    }
}