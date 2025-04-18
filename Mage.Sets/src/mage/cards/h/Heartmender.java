package mage.cards.h;

import java.util.UUID;
import mage.MageInt;
import mage.abilities.Ability;
import mage.abilities.triggers.BeginningOfUpkeepTriggeredAbility;
import mage.abilities.effects.OneShotEffect;
import mage.abilities.keyword.PersistAbility;
import mage.cards.CardImpl;
import mage.cards.CardSetInfo;
import mage.constants.CardType;
import mage.constants.SubType;
import mage.constants.Outcome;
import mage.counters.Counter;
import mage.counters.CounterType;
import mage.filter.StaticFilters;
import mage.game.Game;
import mage.game.permanent.Permanent;

/**
 *
 * @author jeffwadsworth
 */
public final class Heartmender extends CardImpl {

    public Heartmender(UUID ownerId, CardSetInfo setInfo) {
        super(ownerId,setInfo,new CardType[]{CardType.CREATURE},"{2}{G/W}{G/W}");
        this.subtype.add(SubType.ELEMENTAL);
        this.power = new MageInt(2);
        this.toughness = new MageInt(2);

        // At the beginning of your upkeep, remove a -1/-1 counter from each creature you control.
        this.addAbility(new BeginningOfUpkeepTriggeredAbility(new HeartmenderEffect(CounterType.M1M1.createInstance())));

        // Persist
        this.addAbility(new PersistAbility());

    }

    private Heartmender(final Heartmender card) {
        super(card);
    }

    @Override
    public Heartmender copy() {
        return new Heartmender(this);
    }
}

class HeartmenderEffect extends OneShotEffect {

    private final Counter counter;

    HeartmenderEffect(Counter counter) {
        super(Outcome.BoostCreature);
        this.counter = counter;
        staticText = "remove a -1/-1 counter from each creature you control";
    }

    private HeartmenderEffect(final HeartmenderEffect effect) {
        super(effect);
        this.counter = effect.counter.copy();
    }

    @Override
    public boolean apply(Game game, Ability source) {
        boolean applied = false;
        if (game.getBattlefield().getActivePermanents(StaticFilters.FILTER_CONTROLLED_CREATURE, source.getControllerId(), game).isEmpty()) {
            return true;
        }
        for (Permanent creature : game.getBattlefield().getActivePermanents(StaticFilters.FILTER_CONTROLLED_CREATURE, source.getControllerId(), game)) {
            if (creature != null
                    && creature.getCounters(game).getCount(counter.getName()) >= counter.getCount()) {
                creature.removeCounters(counter.getName(), counter.getCount(), source, game);
                game.informPlayers("Removed " + counter.getCount() + ' ' + counter.getName() +
                        " counter from " + creature.getName());
                applied = true;
            }
        }
        return applied;
    }

    @Override
    public HeartmenderEffect copy() {
        return new HeartmenderEffect(this);
    }
}
